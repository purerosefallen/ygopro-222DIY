--库拉丽丝-翩翩
function c57300025.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c57300025.fscon)
	e1:SetOperation(c57300025.fsop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(aux.fuslimit)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(57300025,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,1)
	e5:SetCost(c57300025.cost)
	e5:SetTarget(c57300025.sptg)
	e5:SetOperation(c57300025.spop)
	c:RegisterEffect(e5)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(57300025,1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetHintTiming(0,0x1e0)
	e5:SetCountLimit(1,1)
	e5:SetCost(c57300025.cost)
	e5:SetTarget(c57300025.target)
	e5:SetOperation(c57300025.activate)
	c:RegisterEffect(e5)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(57300025,2))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,1)
	e2:SetCost(c57300025.cost)
	e2:SetCondition(c57300025.discon)
	e2:SetTarget(c57300025.distg)
	e2:SetOperation(c57300025.disop)
	c:RegisterEffect(e2)
end
function c57300025.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.IsExistingMatchingCard(c57300025.cfilter,tp,LOCATION_MZONE,0,1,nil) then
			e:SetLabel(1)
			return true
		end
		return Duel.IsExistingMatchingCard(c57300025.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil)
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c57300025.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c57300025.cfilter(c)
	return c:IsSetCard(0x570) and c:IsAbleToGraveAsCost()
end
function c57300025.fsfilter(c,fc)
	return c:IsCanBeFusionMaterial(fc) and c:IsSetCard(0x570)
end
function c57300025.fscon(e,g,gc,chkfnf)
	if g==nil then return true end
	local sg=Group.CreateGroup()
	local fs=false
	local chkf=bit.band(chkfnf,0xff)
	local mg=g:Filter(c57300025.fsfilter,nil,e:GetHandler())
	if gc then
		if not c57300025.fsfilter(gc,fc) then return false end
		sg:AddCard(gc)
	end	
	return c57300025.CheckGroup(mg,c57300025.fgoal,sg,1,5,e:GetHandler(),e:GetHandlerPlayer(),chkf)
end
function c57300025.val(c)
	return (0x10000*c:GetOverlayCount())+1
end
function c57300025.fgoal(g,fc,tp,chkf)
	local ct=g:GetCount()
	if chkf~=PLAYER_NONE and Duel.GetLocationCountFromEx(chkf,tp,g,fc)<=0 then return false end
	if aux.FCheckAdditional and not aux.FCheckAdditional(tp,g,fc) then return false end
	return g:CheckWithSumEqual(c57300025.val,5,ct,ct)
end
function c57300025.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
	local sg=Group.CreateGroup()
	if gc then sg:AddCard(gc) end
	local fs=false
	local chkf=bit.band(chkfnf,0xff)
	local mg=eg:Filter(c57300025.fsfilter,nil,e:GetHandler())	
	local tg=c57300025.SelectGroup(tp,HINTMSG_FMATERIAL,mg,c57300025.fgoal,sg,1,5,e:GetHandler(),tp,chkf)
	Duel.SetFusionMaterial(tg) 
end
function c57300025.CheckGroupRecursive(c,sg,g,f,min,max,ext_params)
	sg:AddCard(c)
	local ct=sg:GetCount()
	local res=(ct>=min and f(sg,table.unpack(ext_params)))
		or (ct<max and g:IsExists(c57300025.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params))
	sg:RemoveCard(c)
	return res
end
function c57300025.CheckGroup(g,f,cg,min,max,...)
	local min=min or 1
	local max=max or g:GetCount()
	if min>max then return false end
	local ext_params={...}
	local sg=Group.CreateGroup()
	if cg then sg:Merge(cg) end
	local ct=sg:GetCount()
	if ct>=min and ct<max and f(sg,...) then return true end
	return g:IsExists(c57300025.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params)
end
function c57300025.SelectGroup(tp,desc,g,f,cg,min,max,...)
	local min=min or 1
	local max=max or g:GetCount()
	local ext_params={...}
	local sg=Group.CreateGroup()
	if cg then sg:Merge(cg) end
	local ct=sg:GetCount()
	while ct<max and not (ct>=min and f(sg,...) and not (g:IsExists(c57300025.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params) and Duel.SelectYesNo(tp,210))) do
		Duel.Hint(HINT_SELECTMSG,tp,desc)
		local tg=g:FilterSelect(tp,c57300025.CheckGroupRecursive,1,1,sg,sg,g,f,min,max,ext_params)
		sg:Merge(tg)
		ct=sg:GetCount()
	end
	return sg
end
function c57300025.spfilter(c,e,tp)
	if c:IsLocation(LOCATION_GRAVE) and c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	return c:IsSetCard(0x570) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c57300025.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=1
		if e:GetLabel()==1 then ft=0 end
		e:SetLabel(0)
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end
		return Duel.GetMZoneCount(tp)>ft
			and Duel.IsExistingMatchingCard(c57300025.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
			and Duel.IsExistingMatchingCard(c57300025.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c57300025.spop(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(0)
	if not c57300025.sptg(e,tp,eg,ep,ev,re,r,rp,0) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c57300025.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local g2=Duel.SelectMatchingCard(tp,c57300025.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	g:Merge(g2)
	for tc in aux.Next(g) do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
	end
	Duel.SpecialSummonComplete()
end
function c57300025.dfilter(c)
	return true
end
function c57300025.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c57300025.dfilter(chkc) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c57300025.dfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c57300025.dfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	local cat=e:GetCategory()
	if bit.band(g:GetFirst():GetOriginalType(),TYPE_MONSTER)~=0 then
		e:SetCategory(bit.bor(cat,CATEGORY_SPECIAL_SUMMON))
	else
		e:SetCategory(bit.band(cat,bit.bnot(CATEGORY_SPECIAL_SUMMON)))
	end
end
function c57300025.activate(e,tp,eg,ep,ev,re,r,rp)
	local rc=Duel.GetFirstTarget()
	if rc:IsRelateToEffect(e) and Duel.Destroy(rc,REASON_EFFECT)~=0 and not rc:IsLocation(LOCATION_HAND+LOCATION_DECK) then
		if rc:IsType(TYPE_MONSTER) and Duel.GetMZoneCount(tp)>0
			and rc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
			and Duel.SelectYesNo(tp,aux.Stringid(90809975,3)) then
			Duel.BreakEffect()
			Duel.SpecialSummon(rc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,rc)
		elseif (rc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
			and rc:IsSSetable() and Duel.SelectYesNo(tp,aux.Stringid(90809975,4)) then
			Duel.BreakEffect()
			Duel.SSet(tp,rc)
			Duel.ConfirmCards(1-tp,rc)
		end
	end
end
function c57300025.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return Duel.IsChainNegatable(ev)
end
function c57300025.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c57300025.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end