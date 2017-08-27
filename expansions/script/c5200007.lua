--暗精灵-蕾斯蒂亚
function c5200007.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetCountLimit(1,5200007)
	e1:SetCondition(c5200007.spcon)
	e1:SetTarget(c5200007.sptg)
	e1:SetOperation(c5200007.spop)
	c:RegisterEffect(e1)
	 --to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(5200007,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCountLimit(1,52000071)
	e2:SetTarget(c5200007.sp2tg)
	e2:SetOperation(c5200007.sp2op)
	c:RegisterEffect(e2) 
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(5200007,1))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCountLimit(1,52000072)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CHAIN_UNIQUE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(TIMING_BATTLE_START+TIMING_BATTLE_END,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e3:SetTarget(c5200007.target)
	e3:SetOperation(c5200007.operation)
	c:RegisterEffect(e3)
end
function c5200007.spfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and c:IsSetCard(0x360) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function c5200007.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c5200007.spfilter,1,nil,tp)
end
function c5200007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c5200007.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetRange(LOCATION_MZONE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetOperation(c5200007.tgop)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1,true)
	end
end
function c5200007.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
function c5200007.filter3(c)
	return c:IsAbleToHand()
end
function c5200007.sp2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5200007.filter3,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c5200007.filter3,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c5200007.sp2op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c5200007.filter3,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c5200007.tcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x360) and c:IsAttribute(ATTRIBUTE_DARK) and not c:IsCode(5200007)
end
function c5200007.eqfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsCode(5200021)
end
function c5200007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:IsControler(tp) and c5200007.tcfilter(chkc) end
	local ph=Duel.GetCurrentPhase()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():IsReleasable()
		and Duel.IsExistingTarget(c5200007.tcfilter,tp,LOCATION_MZONE,0,1,nil) and  (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
		and Duel.IsExistingMatchingCard(c5200007.eqfilter,tp,0x13,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(5200007,1))
	Duel.SelectTarget(tp,c5200007.tcfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c5200007.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c5200007.eqfilter,tp,0x13,0,1,1,nil)
		if g:GetCount()>0 and Duel.Release(e:GetHandler(),REASON_EFFECT)>0 then
			Duel.Equip(tp,g:GetFirst(),tc)
		end
	end
end

