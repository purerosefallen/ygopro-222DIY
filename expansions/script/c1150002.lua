--茜色之绊
function c1150002.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1150002+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c1150002.tg1)
	e1:SetOperation(c1150002.op1)
	c:RegisterEffect(e1)   
--
end
--
function c1150002.tfilter1(c,e,tp)
	return c:IsFaceup() and c:GetLevel()<5 and Duel.IsExistingMatchingCard(c1150002.tfilter01,tp,LOCATION_GRAVE,0,1,nil,e,tp,c) and not c:IsType(TYPE_XYZ) and not c:IsType(TYPE_FUSION) and not c:IsType(TYPE_SYNCHRO) and not c:IsType(TYPE_LINK)
end
function c1150002.tfilter01(c,e,tp,tc)
	return c:GetOriginalLevel()==tc:GetOriginalLevel() and c:GetOriginalRace()==tc:GetOriginalRace() and c:GetOriginalAttribute()==tc:GetOriginalAttribute() and c:GetCode()~=tc:GetCode() and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsType(TYPE_XYZ) and not c:IsType(TYPE_FUSION) and not c:IsType(TYPE_SYNCHRO) and not c:IsType(TYPE_LINK)
end
function c1150002.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c1150002.tfilter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c1150002.tfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c1150002.tfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
end
--
function c1150002.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)>0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,c1150002.tfilter01,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,tc)
			if sg:GetCount()>0 then
				local tc2=sg:GetFirst()
				if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 then
					local fid=c:GetFieldID()
					local code1=tc:GetOriginalCode()
					local code2=tc2:GetOriginalCode()
					if tc2:IsType(TYPE_EFFECT) then
						tc:CopyEffect(code2,RESET_EVENT+0x1fe0000,0)
					end
					if tc:IsType(TYPE_EFFECT) then
						tc2:CopyEffect(code1,RESET_EVENT+0x1fe0000,0)
					end
					tc:RegisterFlagEffect(1150002,RESET_EVENT+0x1fe0000,0,1,fid)
					tc2:RegisterFlagEffect(1150002,RESET_EVENT+0x1fe0000,0,1,fid)
					local gn=Group.CreateGroup()
					gn:AddCard(tc)
					gn:AddCard(tc2)
					gn:KeepAlive()
					local e1_4=Effect.CreateEffect(e:GetHandler())
					e1_4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1_4:SetCode(EVENT_PHASE+PHASE_END)
					e1_4:SetCountLimit(1)
					e1_4:SetLabel(fid)
					e1_4:SetLabelObject(gn)
					e1_4:SetCondition(c1150002.con1_4)
					e1_4:SetOperation(c1150002.op1_4)
					if Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()==PHASE_END then
						e1_4:SetLabel(Duel.GetTurnCount())
						e1_4:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
					else
						e1_4:SetLabel(0)
						e1_4:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
					end
					Duel.RegisterEffect(e1_4,tp)
				end
			end
		end
	end
end
--
function c1150002.con1_4(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c1150002.filter1_4,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	end
	return Duel.GetTurnPlayer()~=tp and Duel.GetTurnCount()~=e:GetLabel()
end
--
function c1150002.filter1_4(c)
	return c:GetFlagEffectLabel(1150002)==fid
end
--
function c1150002.op1_4(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c1150002.filter1_4,nil)
	g:DeleteGroup()
	Duel.Destroy(tg,REASON_EFFECT)
end
--
