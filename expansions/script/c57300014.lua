--库拉丽丝-终曲
function c57300014.initial_effect(c)
	c:EnableReviveLimit()
--xs
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetLabel(2)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c57300014.xyzcon)
	e1:SetOperation(c57300014.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	 --material
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c57300014.target)
	e2:SetOperation(c57300014.operation)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c57300014.discon)
	e3:SetCost(c57300014.discost)
	e3:SetTarget(c57300014.distg)
	e3:SetOperation(c57300014.disop)
	c:RegisterEffect(e3)
end
function c57300014.mfilter(c,xyzc)
	return c:IsFaceup() and c:IsSetCard(0x570) and c:IsXyzType(TYPE_XYZ) and c:IsCanBeXyzMaterial(xyzc) and c:GetRank()==2
end
function c57300014.xyzfilter(c,mg,sg,ct,min,max,tp,xyzc)
	sg:AddCard(c)
	local i=sg:GetCount()
	local res=(i>=min and c57300014.xyzgoal(sg,ct,tp,xyzc))
		or (i<max and mg:IsExists(c57300014.xyzfilter,1,sg,mg,sg,ct,min,max,tp,xyzc))
	sg:RemoveCard(c)
	return res
end
function c57300014.xyzgoal(g,ct,tp,xyzc)
	local i=g:GetCount()
	if not g:CheckWithSumEqual(c57300014.xyzval,ct,i,i) then return false end
	return Duel.GetLocationCountFromEx(tp,tp,g,xyzc)>0 
end
function c57300014.xyzval(c)
	local v=1
	if c:IsHasEffect(57300021) then v=v+0x20000 end
	return v
end
function c57300014.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=nil
	if og then
		mg=og:Filter(c57300014.mfilter,nil,c)
	else
		mg=Duel.GetMatchingGroup(c57300014.mfilter,tp,LOCATION_MZONE,0,nil,c)
	end
	local ct=e:GetLabel()
	local sg=Group.CreateGroup()
	local min=min or 1
	local max=max and math.min(max,ct) or ct
	return min<=max and mg:IsExists(c57300014.xyzfilter,1,sg,mg,sg,ct,min,max,tp,c)
end
function c57300014.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
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
		mg=og:Filter(c57300014.mfilter,nil,c)
	else
		mg=Duel.GetMatchingGroup(c57300014.mfilter,tp,LOCATION_MZONE,0,nil,c)
	end
	local ct=e:GetLabel()
	local sg=Group.CreateGroup()
	local min=min or 1
	local max=max and math.min(max,ct) or ct
	local i=sg:GetCount()
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=mg:FilterSelect(tp,c57300014.xyzfilter,1,1,sg,mg,sg,ct,min,max,tp,c)
		sg:Merge(g)
		i=sg:GetCount()
	until i>=max or (i>=min and c57300014.xyzgoal(sg,ct,tp,xyzc) and not (mg:IsExists(c57300014.xyzfilter,1,sg,mg,sg,ct,min,max,tp,c) and Duel.SelectYesNo(tp,210)))
	local tg=Group.CreateGroup()
	for tc in aux.Next(sg) do
		tg:Merge(tc:GetOverlayGroup())
	end
	c:SetMaterial(sg)
	Duel.SendtoGrave(tg,REASON_RULE)
	Duel.Overlay(c,sg)  
end
function c57300014.filter(c,tp)
	return not c:IsType(TYPE_TOKEN) and (c:IsControler(tp) or c:IsAbleToChangeControler())
end
function c57300014.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c57300014.filter(chkc,tp) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingTarget(c57300014.filter,tp,0,LOCATION_ONFIELD,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c57300014.filter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler(),tp)
end
function c57300014.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function c57300014.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c57300014.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c57300014.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c57300014.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end