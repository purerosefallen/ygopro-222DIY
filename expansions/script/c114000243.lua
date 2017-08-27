--★仇討ち（あだうち）の魔法少女　杏里あいり
function c114000243.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCondition(c114000243.spcon)
	e1:SetCost(c114000243.spcost)
	e1:SetTarget(c114000243.sptg)
	e1:SetOperation(c114000243.spop)
	c:RegisterEffect(e1)
	if not c114000243.global_check then
		c114000243.global_check=true
		c114000243[0]=false
		--c114000243[1]=false
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROY)
		ge1:SetOperation(c114000243.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c114000243.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
--sp summon part 1 global check
function c114000243.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		local pos=tc:GetPosition()
		--if Duel.GetCurrentPhase()==PHASE_DAMAGE then pos=tc:GetBattlePosition() end
		if tc:IsLocation(LOCATION_MZONE)
			and 		
			( tc:IsSetCard(0x223) or tc:IsSetCard(0x224) 
			or tc:IsCode(36405256) or tc:IsCode(54360049) or tc:IsCode(37160778) or tc:IsCode(27491571) or tc:IsCode(80741828) or tc:IsCode(90330453) --0x223
			or tc:IsCode(32751480) or tc:IsCode(78010363) or tc:IsCode(39432962) or tc:IsCode(67511500) or tc:IsCode(62379337) or tc:IsCode(23087070) or tc:IsCode(17720747) or tc:IsCode(98358303) or tc:IsCode(91584698) ) --0x224
			and bit.band(pos,POS_FACEUP)~=0 then
			--c114000243[tc:GetControler()]=true
			c114000243[0]=true
		end
		tc=eg:GetNext()
	end
end
function c114000243.clear(e,tp,eg,ep,ev,re,r,rp)
	c114000243[0]=false
	--c114000243[1]=false
end
function c114000243.spcon(e,tp,eg,ep,ev,re,r,rp)
	return c114000243[0]
end
--flag registration
function c114000243.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,114000243)==0 end
	Duel.RegisterFlagEffect(tp,114000243,RESET_PHASE+PHASE_END,0,1)
end
--sp summon part 1
function c114000243.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return --e:GetHandler():IsRelateToEffect(e) and 
		Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c114000243.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		--sp summon token part
		e2=Effect.CreateEffect(c)
		e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
		e2:SetCode(EVENT_TO_GRAVE)		
		e2:SetReset(RESET_EVENT+0x17a0000) --RESET_TODECK+RESET_TOHAND+RESET_TEMP_REMOVE=700,000
										  --RESET_REMOVE+RESET_TURN_SET=a0,000
										  --RESET_TOFIELD=1,000,000
		e2:SetCondition(c114000243.con)
		e2:SetTarget(c114000243.tg)
		e2:SetOperation(c114000243.op)
		c:RegisterEffect(e2)	
		--c:RegisterFlagEffect(114000243,RESET_EVENT+0x17a0000,0,1)
	end
end
--token summon
function c114000243.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp~=tp and c:IsReason(REASON_DESTROY)
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp
		--and c:GetFlagEffect(114000243)>0
end
function c114000243.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove()
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local c=e:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	--c:ResetFlagEffect(114000243)
end
function c114000243.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)~=0
	and Duel.IsPlayerCanSpecialSummonMonster(tp,114000244,0x223,0x4011,2300,2300,6,RACE_SPELLCASTER,ATTRIBUTE_DARK) then
		local token=Duel.CreateToken(tp,114000244) --0x4011=TYPE_TOKEN(4000)+TYPE_NORMAL(10)+TYPE_MONSTER(1)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end