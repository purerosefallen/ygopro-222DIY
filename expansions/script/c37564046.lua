--元灵的聚集·Bronya
local m=37564046
local cm=_G["c"..m]

xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_elem=true
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,Senya.check_set_elem,cm.mf,1,63,true)
	local ge2=Effect.CreateEffect(c)
	ge2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
	ge2:SetCondition(cm.mtcon)
	ge2:SetOperation(cm.mtop)
	c:RegisterEffect(ge2)
	local ge3=Effect.CreateEffect(c)
	ge3:SetType(EFFECT_TYPE_SINGLE)
	ge3:SetCode(EFFECT_MATERIAL_CHECK)
	ge3:SetValue(cm.valcheck)
	ge3:SetLabelObject(ge2)
	c:RegisterEffect(ge3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetCondition(cm.descon)
	e4:SetOperation(cm.desop)
	c:RegisterEffect(e4)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(m*16+1)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,0x1c0)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.mcon(ATTRIBUTE_DARK))
	e1:SetTarget(cm.target1)
	e1:SetOperation(cm.operation1)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(37564765,5))
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SPSUMMON)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.discon)
	--e3:SetCost(cm.cost)
	e3:SetTarget(cm.distg)
	e3:SetOperation(cm.disop)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(m*16+3)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.mcon(ATTRIBUTE_FIRE))
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(m*16+4)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(cm.mcon(ATTRIBUTE_WIND))
	e5:SetTarget(cm.target)
	e5:SetOperation(cm.activate)
	c:RegisterEffect(e5)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetValue(aux.tgoval)
	e8:SetCondition(cm.mcon(ATTRIBUTE_EARTH))
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e9:SetCondition(cm.mcon(ATTRIBUTE_EARTH))
	e9:SetValue(1)
	c:RegisterEffect(e9)
end
function cm.mf(c)
	return c:IsFusionType(TYPE_XYZ) and c:GetRank()==4
end
function cm.valcheck(e,c)
	local g=c:GetMaterial()
	local ct=0
	local tc=g:GetFirst()
	while tc do
		ct=bit.bor(tc:GetAttribute(),ct)
		tc=g:GetNext()
	end
	e:GetLabelObject():SetLabel(ct)
end
function cm.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION and e:GetLabel()>0
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,0,1,ct)
end
function cm.mcon(at)
return function(e)
	local mt=e:GetHandler():GetFlagEffectLabel(m)
	return mt and bit.band(at,mt)==at
end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsAbleToGrave() and cm.mcon(ATTRIBUTE_LIGHT)(e)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=e:GetHandler():GetBattleTarget()
	Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode())
	if c:IsRelateToBattle() and bc:IsRelateToBattle() then
		Duel.SendtoGrave(bc,REASON_EFFECT)
	end
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and aux.disfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,aux.disfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
end
function cm.filter(c,tp)
	return c:GetSummonPlayer()==tp
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and eg:IsExists(cm.filter,1,nil,1-tp) and cm.mcon(ATTRIBUTE_WATER)(e)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(cm.filter,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.filter,nil,1-tp)
	Duel.NegateSummon(g)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.dfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and cm.dfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(cm.dfilter,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.dfilter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	local cat=e:GetCategory()
	if bit.band(g:GetFirst():GetOriginalType(),TYPE_MONSTER)~=0 then
		e:SetCategory(bit.bor(cat,CATEGORY_SPECIAL_SUMMON))
	else
		e:SetCategory(bit.band(cat,bit.bnot(CATEGORY_SPECIAL_SUMMON)))
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local rc=Duel.GetFirstTarget()
	if rc:IsRelateToEffect(e) and Duel.Destroy(rc,REASON_EFFECT)~=0 and not rc:IsLocation(LOCATION_HAND+LOCATION_DECK) then
		if rc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
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