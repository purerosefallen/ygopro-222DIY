--旧地狱 恶魂街
function c10129008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(10129008,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,10129008)
	e2:SetCondition(c10129008.thcon)
	e2:SetTarget(c10129008.thtg)
	e2:SetOperation(c10129008.thop)
	c:RegisterEffect(e2)	 
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10129008,1))
	e3:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,10129108)
	e3:SetCondition(c10129008.spcon)
	e3:SetTarget(c10129008.sptg)
	e3:SetOperation(c10129008.spop)
	c:RegisterEffect(e3)  
end
c10129008.card_code_list={10129007}
function c10129008.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10129008.confilter2,1,nil,tp)
end
function c10129008.confilter2(c,tp)
	return c:IsPreviousLocation(LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_HAND) and c:GetPreviousControler()==tp and c:IsRace(RACE_ZOMBIE) and c:IsFaceup()
end
function c10129008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,10129012,0,0x4011,0,0,1,RACE_ZOMBIE,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c10129008.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
	or not Duel.IsPlayerCanSpecialSummonMonster(tp,10129012,0,0x4011,0,0,1,RACE_ZOMBIE,ATTRIBUTE_DARK) or not e:GetHandler():IsRelateToEffect(e) then return end
	local token=Duel.CreateToken(tp,10129012)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e1)
	end
end
function c10129008.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10129008.confilter,1,nil,tp)
end
function c10129008.confilter(c,tp)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_FUSION+101)==SUMMON_TYPE_FUSION+101 and c:GetSummonPlayer()==tp
end
function c10129008.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local sg=c10129008.Fusion_Material_Function(eg,e,tp)
	if chkc then return sg:IsContains(chkc) end
	if chk==0 then return sg:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=sg:Select(tp,1,1,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c10129008.Fusion_Material_Function(eg,e,tp)
	local tg=eg:Filter(c10129008.confilter,nil,tp)
	local sg=Group.CreateGroup()
	local tc=tg:GetFirst()
	while tc do
	  local mg=tc:GetMaterial()
	  if mg:GetCount()>0 then
		 local mg2=mg:Filter(c10129008.fmfilter,nil,e,tp,tc)
		 sg:Merge(mg2)
	  end
	tc=tg:GetNext()
	end
	return sg
end
function c10129008.fmfilter(c,e,tp,fusc)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and bit.band(c:GetReason(),0x40008)==0x40008 and c:GetReasonCard()==fusc and c:IsCanBeEffectTarget(e) and c:IsFaceup()
end
function c10129008.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end


