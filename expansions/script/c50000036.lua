--Warpko 岚剠
function c50000036.initial_effect(c)
	--sp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50000036,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,50000036)
	e1:SetCost(c50000036.ncost)
	e1:SetTarget(c50000036.ntg)
	e1:SetOperation(c50000036.nop)
	c:RegisterEffect(e1) 
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50000036,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCountLimit(1,500000361)
	e2:SetCondition(c50000036.spcon)
	e2:SetTarget(c50000036.sptg)
	e2:SetOperation(c50000036.spop)
	c:RegisterEffect(e2)
end
function c50000036.ncost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c50000036.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x50a) and not c:IsCode(50000036)
end
function c50000036.ntg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c50000036.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c50000036.filter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c50000036.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
end
function c50000036.nop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(c50000036.efilter)
		e1:SetOwnerPlayer(tp)
		tc:RegisterEffect(e1)
		Duel.BreakEffect()
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
	end
end
function c50000036.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end

function c50000036.spcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
function c50000036.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.GetMZoneCount(tp)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c50000036.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end