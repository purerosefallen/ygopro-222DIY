--库拉丽丝-初梦
function c57300013.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetLabel(3)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c57300013.xyzcon)
	e1:SetOperation(c57300013.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(57300013,0))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_BATTLE_START)
	e5:SetCondition(c57300013.descon)
	e5:SetTarget(c57300013.destg)
	e5:SetOperation(c57300013.desop)
	c:RegisterEffect(e5)
end
function c57300013.mfilter(c,xyzc)
	return c:IsFaceup() and c:IsSetCard(0x570) and c:IsCanBeXyzMaterial(xyzc) and c:IsXyzLevel(xyzc,2)
end
function c57300013.xyzfilter(c,mg,sg,ct,min,max,tp,xyzc)
	sg:AddCard(c)
	local i=sg:GetCount()
	local res=(i>=min and c57300013.xyzgoal(sg,ct,tp,xyzc))
		or (i<max and mg:IsExists(c57300013.xyzfilter,1,sg,mg,sg,ct,min,max,tp,xyzc))
	sg:RemoveCard(c)
	return res
end
function c57300013.xyzgoal(g,ct,tp,xyzc)
	local i=g:GetCount()
	if not g:CheckWithSumEqual(c57300013.xyzval,ct,i,i) then return false end
	--to be changed in mr4
	--return Duel.GetLocationCountFromEx(tp,tp,g,xyzc)>0
	return Duel.GetLocationCountFromEx(tp,tp,g,xyzc)>0 
end
function c57300013.xyzval(c)
	local v=1
	if c:IsHasEffect(57300021) then v=v+0x20000 end
	return v
end
function c57300013.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=nil
	if og then
		mg=og:Filter(c57300013.mfilter,nil,c)
	else
		mg=Duel.GetMatchingGroup(c57300013.mfilter,tp,LOCATION_MZONE,0,nil,c)
	end
	local ct=e:GetLabel()
	local sg=Group.CreateGroup()
	local min=min or 1
	local max=max and math.min(max,ct) or ct
	return min<=max and mg:IsExists(c57300013.xyzfilter,1,sg,mg,sg,ct,min,max,tp,c)
end
function c57300013.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local mg=nil
	if og then
		if not min then
			local tg=Group.CreateGroup()
			for tc in aux.Next(og) do
				tg:Merge(tc:GetOverlayGroup())
			end
			c:SetMaterial(og)
			Duel.SendtoGrave(tg,REASON_RULE)
			Duel.Overlay(c,og)
			return
		end
		mg=og:Filter(c57300013.mfilter,nil,c)
	else
		mg=Duel.GetMatchingGroup(c57300013.mfilter,tp,LOCATION_MZONE,0,nil,c)
	end
	local ct=e:GetLabel()
	local sg=Group.CreateGroup()
	local min=min or 1
	local max=max and math.min(max,ct) or ct
	local i=sg:GetCount()
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=mg:FilterSelect(tp,c57300013.xyzfilter,1,1,sg,mg,sg,ct,min,max,tp,c)
		sg:Merge(g)
		i=sg:GetCount()
	until i>=max or (i>=min and c57300013.xyzgoal(sg,ct,tp,xyzc) and not (mg:IsExists(c57300013.xyzfilter,1,sg,mg,sg,ct,min,max,tp,c) and Duel.SelectYesNo(tp,210)))
	local tg=Group.CreateGroup()
	for tc in aux.Next(sg) do
		tg:Merge(tc:GetOverlayGroup())
	end
	c:SetMaterial(sg)
	Duel.SendtoGrave(tg,REASON_RULE)
	Duel.Overlay(c,sg)  
end
function c57300013.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and not bc:IsType(TYPE_TOKEN)
end
function c57300013.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) end
end
function c57300013.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToBattle() and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end