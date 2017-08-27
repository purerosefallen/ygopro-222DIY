--★風の魔女っ娘　Ｓｙｍｐｈｏｎｙ　Ｔｈｅ　Ｃｏｂａｌｔ（シンフォニー・ザ・コバルト）
function c114000193.initial_effect(c)
	c:SetStatus(STATUS_UNSUMMONABLE_CARD,true)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c114000193.spcost)
	e1:SetTarget(c114000193.sptg)
	e1:SetOperation(c114000193.spop)
	c:RegisterEffect(e1)
	--indestructable once
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetCountLimit(1)
	e2:SetValue(c114000193.valcon)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c114000193.atkcon)
	e3:SetOperation(c114000193.operation)
	c:RegisterEffect(e3)
end
--sp summon function
function c114000193.spcfilter(c)
	return ( c:IsSetCard(0x221) or c:IsCode(114000231) )
end
function c114000193.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c114000193.spcfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c114000193.spcfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c114000193.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c114000193.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--indestructable val
function c114000193.valcon(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		e:GetHandler():RegisterFlagEffect(114000193,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		return true
	end
end
--atk up function
function c114000193.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(114000193)>0
end
function c114000193.operation(e,tp,eg,ep,ev,re,r,rp)
        local c=e:GetHandler()
        if c:IsFaceup() and c:IsRelateToEffect(e) then
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_ATTACK)
                e1:SetValue(200)
                e1:SetReset(RESET_EVENT+0x1ff0000)
                c:RegisterEffect(e1)
        end
end