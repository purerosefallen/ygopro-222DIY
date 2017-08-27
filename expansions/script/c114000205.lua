--★ナースウィッチ小麦ちゃん
function c114000205.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c114000205.spcon)
	e1:SetOperation(c114000205.spop)
	c:RegisterEffect(e1)
	--set
	e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetTarget(c114000205.schtg)
	e2:SetOperation(c114000205.setop)
	c:RegisterEffect(e2)
end
function c114000205.spcon(e,c)
        if c==nil then return true end
        return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
                and Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>0
                and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
-- cannot sp summon other non 0x221 only "after"
function c114000205.splimit(e,c)
	return not ( c:IsSetCard(0x221) or c:IsCode(114000231) )
end
function c114000205.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c114000205.splimit)
	Duel.RegisterEffect(e1,tp)
end
--set function
function c114000205.filter(c,tp) -- required extra value "tp" to be inserted
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
		and c:GetReasonPlayer()==1-tp and c:IsReason(REASON_DESTROY) -- destroyed by opponent's effects
end
function c114000205.schtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c114000205.filter,tp,LOCATION_GRAVE,0,1,nil,tp) end --requires an extra value "tp" to 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)                                       --determine reason_player
	Duel.SelectTarget(tp,c114000205.filter,tp,LOCATION_GRAVE,0,1,1,nil,tp)          --same as above
end
function c114000205.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsSSetable() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end