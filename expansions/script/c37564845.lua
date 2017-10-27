--3L·梦色世界
local m=37564845
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_3L=true
function cm.initial_effect(c)
	--Senya.setreg(c,m,37564800)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	--e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(m)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_FZONE)
	c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(Senya.DescriptionInNanahira(0))
		e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetRange(LOCATION_FZONE)
		e2:SetCountLimit(1)
		e2:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
		e2:SetCondition(cm.rmcon)
		e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
			if chk==0 then return Duel.GetMZoneCount(tp)>0
				and Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
		end)
		e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			if not e:GetHandler():IsRelateToEffect(e) then return end
			if Duel.GetMZoneCount(tp)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
			local tc=g:GetFirst()
			if tc then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
				local fid=e:GetHandler():GetFieldID()
				tc:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,0,1,fid)
				tc:SetCardTarget(e:GetHandler())
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetCountLimit(1)
				e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetLabel(fid)
				e1:SetLabelObject(tc)
				e1:SetCondition(cm.thcon)
				e1:SetOperation(cm.thop)
				Duel.RegisterEffect(e1,tp)
				if Senya.EffectSourceFilter_3L(tc,tc) then
					local et=Senya.GainEffect_3L(tc,tc)
					for _,te in pairs(et) do
						local con=te:GetCondition()
						te:SetCondition(function(e,...)
							if e:GetHandler():GetCardTarget():IsExists(Card.IsHasEffect,1,nil,m) then
								return (not con or con(e,...))
							else
								Senya.RemoveCertainEffect_3L(e:GetHandler(),e:GetHandler():GetOriginalCode())
								return false
							end							
						end)
					end
				end
			end
		end)
		c:RegisterEffect(e2)
end
function cm.filter1(c,e,tp)
	return Senya.check_set_3L(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(m)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetLabelObject(),nil,REASON_EFFECT)
end
function cm.filter(c)
	return Senya.check_set_3L(c) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(function(e,c)
			if e:GetHandler():IsFacedown() then return false end
			return not c or Senya.check_set_3L(c)
		end)
		tc:RegisterEffect(e1,true)
	end
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
