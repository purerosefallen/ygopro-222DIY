--反叛之誓
function c80015015.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_XMAT_COUNT_LIMIT)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,80015015+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c80015015.cost)
	e1:SetTarget(c80015015.target)
	e1:SetOperation(c80015015.activate)
	c:RegisterEffect(e1) 
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80015015,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,80015016)
	e2:SetCost(c80015015.cost1)
	e2:SetTarget(c80015015.mattg)
	e2:SetOperation(c80015015.matop)
	c:RegisterEffect(e2)
	--xyzlv
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(80015015,1))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,80015017)
	e5:SetCost(c80015015.cost)
	e5:SetOperation(c80015015.operation)
	c:RegisterEffect(e5) 
	Duel.AddCustomActivityCounter(80015015,ACTIVITY_SPSUMMON,c80015015.counterfilter)  
end
function c80015015.counterfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c80015015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(80015015,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c80015015.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c80015015.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_DARK)
end
function c80015015.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and Duel.GetCustomActivityCount(80015015,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c80015015.splimit)
	Duel.RegisterEffect(e1,tp)
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c80015015.filter(c)
	return c:IsSetCard(0x32d7) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c80015015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80015015.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c80015015.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c80015015.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c80015015.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c80015015.xyztg)
	e1:SetValue(c80015015.xyzlv)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c80015015.xyztg(e,c)
	return c:IsLevelBelow(2) and c:IsSetCard(0x32d7)
end
function c80015015.xyzlv(e,c,rc)
	return 0x30030000+c:GetLevel()
end
function c80015015.xyzfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c80015015.matfilter,tp,LOCATION_EXTRA,0,1,c) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c80015015.matfilter(c)
	return c:IsLocation(LOCATION_EXTRA) and c:IsType(TYPE_XYZ) and c:IsRankBelow(3) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c80015015.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c80015015.xyzfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c80015015.xyzfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c80015015.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c80015015.matop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,c80015015.matfilter,tp,LOCATION_EXTRA,0,1,1,tc)
		if g:GetCount()>0 then
			local mg=g:GetFirst():GetOverlayGroup()
			if mg:GetCount()>0 then
				Duel.SendtoGrave(mg,REASON_RULE)
			end
			Duel.Overlay(tc,g)
		end
	end
end