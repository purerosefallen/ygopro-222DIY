--夏日的约会
function c1150018.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetCountLimit(1,1150018+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c1150018.con1)
	e1:SetTarget(c1150018.tg1)
	e1:SetOperation(c1150018.op1)
	c:RegisterEffect(e1)
--  
end
--
function c1150018.cfilter1(c,e,tp)
	return c:IsFaceup() and c:GetLevel()<5 and Duel.IsExistingMatchingCard(c1150018.cfilter1_1,tp,LOCATION_DECK,0,1,nil,e,tp,c) and not c:IsType(TYPE_XYZ)
end
function c1150018.cfilter1_1(c,e,tp,tc)
	return c:GetLevel()==tc:GetLevel() and c:GetOriginalAttribute()~=tc:GetOriginalAttribute() and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsType(TYPE_XYZ)
end
function c1150018.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1150018.cfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
end
--
function c1150018.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c1150018.cfilter1(chkc,e,tp) end
	if chk==0 then 
		if Duel.GetMZoneCount(tp)~=4 then return false end
		return Duel.IsExistingMatchingCard(c1150018.cfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c1150018.cfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
end
--
function c1150018.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)==4 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,c1150018.cfilter1_1,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc)
			if sg:GetCount()>0 then
				local tc2=sg:GetFirst()
				if Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)~=0 then
					local e1_2=Effect.CreateEffect(e:GetHandler())
					e1_2:SetType(EFFECT_TYPE_FIELD)
					e1_2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					e1_2:SetCode(EFFECT_CANNOT_ACTIVATE)
					e1_2:SetTargetRange(1,0)
					e1_2:SetValue(c1150018.limit1_2)
					e1_2:SetLabel(tc2:GetCode())
					e1_2:SetReset(RESET_PHASE+PHASE_END)
					Duel.RegisterEffect(e1_2,tp)
					if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
						local e1_3=Effect.CreateEffect(e:GetHandler())
						e1_3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
						e1_3:SetCode(EVENT_PHASE+PHASE_STANDBY)
						e1_3:SetReset(RESET_PHASE+PHASE_STANDBY,2)
						e1_3:SetLabelObject(tc)
						e1_3:SetCountLimit(1)
						e1_3:SetCondition(c1150018.con1_3)
						e1_3:SetOperation(c1150018.op1_3)
						Duel.RegisterEffect(e1_3,tp)
					end
					if Duel.Remove(tc2,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
						local e1_4=Effect.CreateEffect(e:GetHandler())
						e1_4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
						e1_4:SetCode(EVENT_PHASE+PHASE_STANDBY)
						e1_4:SetReset(RESET_PHASE+PHASE_STANDBY,2)
						e1_4:SetLabelObject(tc2)
						e1_4:SetCountLimit(1)
						e1_4:SetCondition(c1150018.con1_3)
						e1_4:SetOperation(c1150018.op1_3)
						Duel.RegisterEffect(e1_4,tp)
					end
				end
			end
		end
	end
end
--
function c1150018.limit1_2(e,re,tp)
	return re:GetHandler():GetCode()==e:GetLabel()
end
--
function c1150018.con1_3(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
--
function c1150018.op1_3(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
--




