--悲哀·布洛妮娅
local m=14140018
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.xyzcon)
	e2:SetOperation(cm.xyzop)
	e2:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCountLimit(1,m)
	e1:SetCost(function(e)
		e:SetLabel(1)
		return true
	end)
	e1:SetTarget(cm.target0)
	e1:SetOperation(cm.operation0)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m-40000)
	e1:SetCondition(cm.negcon)
	e1:SetCost(cm.negcost)
	e1:SetTarget(cm.negtg)
	e1:SetOperation(cm.negop)
	c:RegisterEffect(e1)
	if not cm.gchk then
		cm.gchk=true
		local card_is_xyz_summonable=Card.IsXyzSummonable
		Card.IsXyzSummonable=function(c,mg,min,max)
			if c:GetOriginalCode()==m and mg==nil then
				local g=Duel.GetMatchingGroup(Card.IsFaceup,c:GetControler(),LOCATION_MZONE,0,nil)
				return card_is_xyz_summonable(c,g,1,g:GetCount())
			end
			return card_is_xyz_summonable(c,mg,min,max)
		end
		local duel_xyz_summon=Duel.XyzSummon
		Duel.XyzSummon=function(tp,c,mg,min,max)
			if c:GetOriginalCode()==m and mg==nil then
				local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
				duel_xyz_summon(tp,c,g,1,g:GetCount())
			end
			duel_xyz_summon(tp,c,mg,min,max)
		end
	end
end
cm.filters={
	[0]=function(c) return c:IsLocation(LOCATION_MZONE) end,
	[1]=function(c) return c:IsXyzType(TYPE_SPELL) end,
	[2]=function(c) return c:IsXyzType(TYPE_TRAP) end,
}
function cm.xyzfilter(c,mg,sg,tp,xyzc)
	if not cm.filters[sg:GetCount()](c) then return false end
	if c:IsLocation(LOCATION_MZONE) and not c:IsCanBeXyzMaterial(xyzc) then return false end
	sg:AddCard(c)
	local res=false
	if sg:GetCount()==3 then
		res=Duel.GetLocationCountFromEx(tp,tp,sg,xyzc)>0
	else
		res=mg:IsExists(cm.xyzfilter,1,sg,mg,sg,tp,xyzc)
	end
	sg:RemoveCard(c)
	return res
end
function cm.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local minc=3
	local maxc=3
	if min then
		minc=math.max(minc,min)
		maxc=math.min(maxc,max)
	end
	local mg=nil
	if og then
		mg=og:Filter(Card.IsFaceup,nil)
	else
		mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,0,nil)
	end
	local sg=Group.CreateGroup()
	return minc<=maxc and mg:IsExists(cm.xyzfilter,1,sg,mg,sg,tp,c)
end
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local sg=nil
	if og and not min then
		sg=og
	else
		sg=Group.CreateGroup()
		local minc=3
		local maxc=3
		if min then
			minc=math.max(minc,min)
			maxc=math.min(maxc,max)
		end
		local mg=nil
		if og then
			mg=og:Filter(Card.IsFaceup,nil)
		else
			mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,0,nil)
		end
		repeat
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local g=mg:FilterSelect(tp,cm.xyzfilter,1,1,sg,mg,sg,tp,c)
			sg:Merge(g)
		until sg:GetCount()==3
	end
	c:SetMaterial(sg)
	local tg=Group.CreateGroup()
	for tc in aux.Next(sg) do
		if tc:IsStatus(STATUS_LEAVE_CONFIRMED) then tc:CancelToGrave() end
		tg:Merge(tc:GetOverlayGroup())
	end
	Duel.SendtoGrave(tg,REASON_RULE)
	Duel.Overlay(c,sg)
end
function cm.filter(c,e,tp)
	return c:IsAbleToRemoveAsCost() and Duel.IsExistingTarget(cm.filter1,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,e:GetHandler(),(c:GetType() & 0x7))
end
function cm.filter1(c,t)
	return c:IsAbleToChangeControler() and not c:IsType(TYPE_TOKEN) and c:IsType((t & 0x7)) and (c:IsType(TYPE_MONSTER) or c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function cm.target0(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and cm.filter1(chkc,e:GetLabelObject():GetType()) and chkc~=e:GetHandler() and chkc:IsControler(1-tp) end
	local l=e:GetLabel()
	e:SetLabel(0)
	if chk==0 then
		return l==1 and e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler(),e,tp)
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler(),e,tp)
	local tc=tg:GetFirst()
	local t=tc:GetType()
	e:SetLabelObject(tc)
	Duel.Remove(tg,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.filter1,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,e:GetHandler(),t)
	local gg=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if gg:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,gg,1,0,LOCATION_GRAVE)
	end
end
function cm.operation0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		if c:IsStatus(STATUS_LEAVE_CONFIRMED) then c:CancelToGrave() end
		Duel.SendtoGrave(tc:GetOverlayGroup(),REASON_RULE)
		Duel.Overlay(c,tc)
	end
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function cm.cfilter(c,rtype)
	return c:IsType(rtype) and c:IsAbleToRemoveAsCost()
end
function cm.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rtype=(re:GetActiveType() & 0x7)
	local og=e:GetHandler():GetOverlayGroup():Filter(cm.cfilter,nil,rtype)
	if chk==0 then return og:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=og:Select(tp,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end