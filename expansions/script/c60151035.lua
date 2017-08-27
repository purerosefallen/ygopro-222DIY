--今后…也要在一起哦……
function c60151035.initial_effect(c)
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_CONTROL+CATEGORY_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_BE_BATTLE_TARGET)
    e1:SetCondition(c60151035.condition)
    e1:SetTarget(c60151035.target)
    e1:SetOperation(c60151035.activate)
    c:RegisterEffect(e1)
end
function c60151035.condition(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    return tc:IsControler(tp) and tc:IsFaceup() and tc:IsSetCard(0x5b23)
		and tc:IsType(TYPE_MONSTER) and tc:IsRace(RACE_SPELLCASTER) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1
end
function c60151035.xyzfilter(c,mg)
	if c.xyz_count~=2 then return false end
	return c:IsSetCard(0x5b23) and c:IsXyzSummonable(nil,mg)
end
function c60151035.filter(c,e,tp)
	return c:IsSetCard(0x5b23) and c:IsRace(RACE_SPELLCASTER)
end
function c60151035.filter2(c,e,tp)
	return c:IsSetCard(0x5b23) and c:IsRace(RACE_FIEND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60151035.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local tg=Duel.GetAttacker()
    if chkc then return chkc==tg end
    if chk==0 then return tg:IsOnField() and tg:IsAbleToChangeControler() 
		and tg:IsCanBeEffectTarget(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingTarget(c60151035.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetTargetCard(tg)
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,tg,1,0,0)
end
function c60151035.spfilter1(c,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsSetCard(0x5b23)
end
function c60151035.spfilter2(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsSetCard(0x5b23) and c:GetLevel()==3
end
function c60151035.spfilter3(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsSetCard(0x5b23) and c:GetLevel()==6
end
function c60151035.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
			if Duel.GetControl(tc,tp,PHASE_END,1) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_RACE)
				e1:SetValue(RACE_SPELLCASTER)
				e1:SetReset(RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				if tc:IsType(TYPE_XYZ) then
					if Duel.GetFirstMatchingCard(c60151035.spfilter2,tp,LOCATION_MZONE,0,nil,c) then
						local e2=Effect.CreateEffect(e:GetHandler())
						e2:SetType(EFFECT_TYPE_SINGLE)
						e2:SetCode(EFFECT_XYZ_LEVEL)
						e2:SetValue(c60151035.xyzlv3)
						e2:SetReset(RESET_PHASE+PHASE_END)
						tc:RegisterEffect(e2)
					end
					if Duel.GetFirstMatchingCard(c60151035.spfilter3,tp,LOCATION_MZONE,0,nil,c) then
						local e3=Effect.CreateEffect(e:GetHandler())
						e3:SetType(EFFECT_TYPE_SINGLE)
						e3:SetCode(EFFECT_XYZ_LEVEL)
						e3:SetValue(c60151035.xyzlv6)
						e3:SetReset(RESET_PHASE+PHASE_END)
						tc:RegisterEffect(e3)
					end
				else
					local e2=Effect.CreateEffect(e:GetHandler())
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_CHANGE_LEVEL)
					e2:SetValue(3)
					e2:SetReset(RESET_PHASE+PHASE_END)
					tc:RegisterEffect(e2)
				end
				local e5=Effect.CreateEffect(e:GetHandler())
				e5:SetType(EFFECT_TYPE_SINGLE)
				e5:SetCode(EFFECT_XYZ_LEVEL)
				e5:SetValue(c60151035.xyzlv6)
				e5:SetReset(RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e5)
			elseif not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
				Duel.Destroy(tc,REASON_EFFECT)
			end
			Duel.SpecialSummonComplete()
			Duel.BreakEffect()
			local o=tc:GetOverlayGroup()
			if o:GetCount()~=0 then
				Duel.SendtoGrave(o,REASON_RULE)
			end
			local g1=Duel.GetFirstMatchingCard(c60151035.spfilter1,tp,LOCATION_MZONE,0,nil,c)
			local mg=Group.FromCards(g1,tc)
			local g=Duel.GetMatchingGroup(c60151035.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
			if g:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=g:Select(tp,1,1,nil)
				Duel.XyzSummon(tp,sg:GetFirst(),nil,mg)
			end
    end
end
function c60151035.xyzlv3(e,c,rc)
    return 0x30000+e:GetHandler():GetLevel()
end
function c60151035.xyzlv6(e,c,rc)
    return 0x60000+e:GetHandler():GetLevel()
end