--库拉丽丝-尝试
function c57300011.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetLabel(2)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c57300011.xyzcon)
	e1:SetOperation(c57300011.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetDescription(aux.Stringid(57300011,0))
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c57300011.cost)
	e1:SetOperation(c57300011.operation)
	c:RegisterEffect(e1)
end
function c57300011.mfilter(c,xyzc)
	return c:IsFaceup() and c:IsSetCard(0x570) and c:IsCanBeXyzMaterial(xyzc) and c:IsXyzLevel(xyzc,2)
end
function c57300011.xyzfilter(c,mg,sg,ct,min,max,tp,xyzc)
	sg:AddCard(c)
	local i=sg:GetCount()
	local res=(i>=min and c57300011.xyzgoal(sg,ct,tp,xyzc))
		or (i<max and mg:IsExists(c57300011.xyzfilter,1,sg,mg,sg,ct,min,max,tp,xyzc))
	sg:RemoveCard(c)
	return res
end
function c57300011.xyzgoal(g,ct,tp,xyzc)
	local i=g:GetCount()
	if not g:CheckWithSumEqual(c57300011.xyzval,ct,i,i) then return false end
	--to be changed in mr4
	--return Duel.GetLocationCountFromEx(tp,tp,g,xyzc)>0
	return Duel.GetLocationCountFromEx(tp,tp,g,xyzc)>0 
end
function c57300011.xyzval(c)
	local v=1
	if c:IsHasEffect(57300021) then v=v+0x20000 end
	return v
end
function c57300011.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=nil
	if og then
		mg=og:Filter(c57300011.mfilter,nil,c)
	else
		mg=Duel.GetMatchingGroup(c57300011.mfilter,tp,LOCATION_MZONE,0,nil,c)
	end
	local ct=e:GetLabel()
	local sg=Group.CreateGroup()
	local min=min or 1
	local max=max and math.min(max,ct) or ct
	return min<=max and mg:IsExists(c57300011.xyzfilter,1,sg,mg,sg,ct,min,max,tp,c)
end
function c57300011.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
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
		mg=og:Filter(c57300011.mfilter,nil,c)
	else
		mg=Duel.GetMatchingGroup(c57300011.mfilter,tp,LOCATION_MZONE,0,nil,c)
	end
	local ct=e:GetLabel()
	local sg=Group.CreateGroup()
	local min=min or 1
	local max=max and math.min(max,ct) or ct
	local i=sg:GetCount()
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=mg:FilterSelect(tp,c57300011.xyzfilter,1,1,sg,mg,sg,ct,min,max,tp,c)
		sg:Merge(g)
		i=sg:GetCount()
	until i>=max or (i>=min and c57300011.xyzgoal(sg,ct,tp,xyzc) and not (mg:IsExists(c57300011.xyzfilter,1,sg,mg,sg,ct,min,max,tp,c) and Duel.SelectYesNo(tp,210)))
	local tg=Group.CreateGroup()
	for tc in aux.Next(sg) do
		tg:Merge(tc:GetOverlayGroup())
	end
	c:SetMaterial(sg)
	Duel.SendtoGrave(tg,REASON_RULE)
	Duel.Overlay(c,sg)  
end
function c57300011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c57300011.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(c:GetBaseAttack()*2)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetValue(function(e,te)
			return te:GetOwner()~=e:GetOwner()
		end)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e3)
	end
end