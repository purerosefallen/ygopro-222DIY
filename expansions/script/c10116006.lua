--真夜鸦大回旋
function c10116006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,10116006+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetTarget(c10116006.target)
	e1:SetOperation(c10116006.activate)
	c:RegisterEffect(e1) 
end

function c10116006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c10116006.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and eg:IsExists(c10116006.filter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=eg:FilterSelect(tp,c10116006.filter,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function c10116006.filter(c,e,tp)
	return c:IsSetCard(0x3331) and c:GetPreviousControler()==tp and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetReasonPlayer()~=tp
end

function c10116006.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
	 local lv=tc:GetLevel()
	 Duel.BreakEffect()
	 local g=Duel.GetMatchingGroup(c10116006.spfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,nil,e,tp)
	 if lv>=4 then
		--battleins
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		--immue
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetValue(c10116006.efilter)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	 end
	 if lv>=6 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount()>0 then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		  local sc=g:Select(tp,1,1,nil):GetFirst()
			if not sc:IsHasEffect(EFFECT_NECRO_VALLEY) then
			   Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			end
	 end
	end
end

function c10116006.spfilter(c,e,tp)
	return c:IsSetCard(0x3331)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end

function c10116006.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end