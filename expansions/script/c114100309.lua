--★理を曲げる少女　小野寺桜乃
function c114100309.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,114100309)
	e1:SetTarget(c114100309.sptg)
	e1:SetOperation(c114100309.spop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c114100309.tgcon)
	e2:SetTarget(c114100309.tgtg)
	e2:SetOperation(c114100309.tgop)
	c:RegisterEffect(e2)
end
--sp summon
function c114100309.filter(c,e,tp)
	return c:GetLevel()==1 and ( c:IsSetCard(0xabb) or c:IsCode(51275027) ) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c114100309.filter2(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0x221) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not ( c:IsSetCard(0xabb) or c:IsCode(51275027) )
end
function c114100309.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local opt=-1
	local check=0
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and ( Duel.IsExistingMatchingCard(c114100309.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
			or Duel.IsExistingMatchingCard(c114100309.filter2,tp,LOCATION_HAND,0,1,nil,e,tp) ) end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c114100309.filter,tp,LOCATION_DECK,0,1,nil,e,tp) then check=check+1 end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c114100309.filter2,tp,LOCATION_HAND,0,1,nil,e,tp) then check=check+2 end
	if check==3 and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then check=check+3 end
	if ( check==1 or check==2 ) then opt=check-1 end
	if check==3 then opt=Duel.SelectOption(tp,aux.Stringid(114100309,0),aux.Stringid(114100309,1)) end
	if check==6 then opt=Duel.SelectOption(tp,aux.Stringid(114100309,0),aux.Stringid(114100309,1),aux.Stringid(114100309,2)) end
	if opt==0 or opt==2 then Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK) end
	if opt==1 or opt==2 then Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND) end
	e:SetLabel(opt)
end
function c114100309.spop(e,tp,eg,ep,ev,re,r,rp)
	local slot=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if slot<=0 then return end
	local opt=e:GetLabel()
	if opt==0 or opt==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c114100309.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
	end
	if slot>0 and ( opt==1 or opt==2 ) then
		if opt==2 then Duel.BreakEffect() end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c114100309.filter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
	end
end
--to grave
function c114100309.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c114100309.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c114100309.tgop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	end
end
